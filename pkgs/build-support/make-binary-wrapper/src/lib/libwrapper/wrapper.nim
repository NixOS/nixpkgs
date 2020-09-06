# This is the code of the wrapper that is generated.

import json
import os
import posix
import sequtils
import strutils

# Wrapper type as used by the wrapper-generation code as well in the actual wrapper.

type
    SetVar* = object
        variable*: string
        value*: string

    SetDefaultVar* = object
        variable*: string
        value*: string
    
    UnsetVar* = object
        variable*: string

    PrefixVar* = object
        variable*: string
        values*: seq[string]
        separator*: string

    SuffixVar* = object
        variable*: string
        values*: seq[string]
        separator*: string

    # Maybe move the members into Wrapper directly?
    Environment* = object
        set*: seq[SetVar]
        set_default*: seq[SetDefaultVar]
        unset*: seq[UnsetVar]
        prefix*: seq[PrefixVar]
        suffix*: seq[SuffixVar]

    Wrapper* = object
        original*: string
        wrapper*: string
        run*: string
        flags*: seq[string]
        environment*: Environment

# File containing wrapper instructions
const jsonFilename = "./wrapper.json"

# Embed the JSON string defining the wrapper in our binary
const jsonString = staticRead(jsonFilename)

proc modifyEnv(item: SetVar) =
    putEnv(item.variable, item.value)

proc modifyEnv(item: SetDefaultVar) =
    if not existsEnv(item.variable):
        putEnv(item.variable, item.value)

proc modifyEnv(item: UnsetVar) =
    if existsEnv(item.variable):
        delEnv(item.variable)

proc modifyEnv(item: PrefixVar) =
    let old_value = if existsEnv(item.variable): getEnv(item.variable) else: ""
    let new_value = join(concat(item.values, @[old_value]), item.separator)
    putEnv(item.variable, new_value)

proc modifyEnv(item: SuffixVar) =
    let old_value = if existsEnv(item.variable): getEnv(item.variable) else: ""
    let new_value = join(concat(@[old_value], item.values), item.separator)
    putEnv(item.variable, new_value)

proc processEnvironment(environment: Environment) =
    for item in environment.unset.items():
        item.modifyEnv()
    for item in environment.set.items():
        item.modifyEnv()
    for item in environment.set_default.items():
        item.modifyEnv()
    for item in environment.prefix.items():
        item.modifyEnv()
    for item in environment.suffix.items():
        item.modifyEnv()


if existsEnv("NIX_DEBUG_WRAPPER"):
    echo(jsonString)
else:
    # Unfortunately parsing JSON during compile-time is not supported.
    let wrapperDescription = parseJson(jsonString)
    let wrapper = to(wrapperDescription, Wrapper)
    processEnvironment(wrapper.environment)
    let argv = wrapper.original # convert target to cstring
    let argc = allocCStringArray(wrapper.flags)

    # Run command in new environment but before executing our executable 
    discard execShellCmd(wrapper.run)
    discard execvp(argv, argc) # Maybe use execvpe instead so we can pass an updated mapping?

    deallocCStringArray(argc)
