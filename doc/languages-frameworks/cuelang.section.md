# Cue (Cuelang) {#cuelang}

[Cuelang](https://cuelang.org/) is a language to:

- describe schemas and validate backward-compatibility
- generate code and schemas in various formats (e.g. JSON Schema, OpenAPI)
- do configuration akin to [Dhall Lang](https://dhall-lang.org/)
- perform data validation

## Cuelang schema quick start

Cuelang schemas are similar to JSON, here is a quick cheatsheet:

- Default types includes: `null`, `string`, `bool`, `bytes`, `number`, `int`, `float`, lists as `[...T]` where `T` is a type.
- All structures, defined by: `myStructName: { <fields> }` are **open** -- they accept fields which are not specified.
- Closed structures can be built by doing `myStructName: close({ <fields> })` -- they are strict in what they accept.
- `#X` are **definitions**, referenced definitions are **recursively closed**, i.e. all its children structures are **closed**.
- `&` operator is the [unification operator](https://cuelang.org/docs/references/spec/#unification) (similar to a type-level merging operator), `|` is the [disjunction operator](https://cuelang.org/docs/references/spec/#disjunction) (similar to a type-level union operator).
- Values **are** types, i.e. `myStruct: { a: 3 }` is a valid type definition that only allows `3` as value.

- Read <https://cuelang.org/docs/concepts/logic/> to learn more about the semantics.
- Read <https://cuelang.org/docs/references/spec/> to learn about the language specification.

## `writeCueValidator`

Nixpkgs provides a `pkgs.writeCueValidator` helper, which will write a validation script based on the provided Cuelang schema.

Here is an example:
```
pkgs.writeCueValidator
  (pkgs.writeText "schema.cue" ''
    #Def1: {
      field1: string
    }
  '')
  { document = "#Def1"; }
```

- The first parameter is the Cue schema file.
- The second parameter is an options parameter, currently, only: `document` can be passed.

`document` : match your input data against this fragment of structure or definition, e.g. you may use the same schema file but different documents based on the data you are validating.

Another example, given the following `validator.nix` :
```
{ pkgs ? import <nixpkgs> {} }:
let
  genericValidator = version:
  pkgs.writeCueValidator
    (pkgs.writeText "schema.cue" ''
      #Version1: {
        field1: string
      }
      #Version2: #Version1 & {
        field1: "unused"
      }''
    )
    { document = "#Version${toString version}"; };
in
{
  validateV1 = genericValidator 1;
  validateV2 = genericValidator 2;
}
```

The result is a script that will validate the file you pass as the first argument against the schema you provided `writeCueValidator`.

It can be any format that `cue vet` supports, i.e. YAML or JSON for example.

Here is an example, named `example.json`, given the following JSON:
```
{ "field1": "abc" }
```

You can run the result script (named `validate`) as the following:

```console
$ nix-build validator.nix
$ ./result example.json
$ ./result-2 example.json
field1: conflicting values "unused" and "abc":
    ./example.json:1:13
    ../../../../../../nix/store/v64dzx3vr3glpk0cq4hzmh450lrwh6sg-schema.cue:5:11
$ sed -i 's/"abc"/3/' example.json
$ ./result example.json
field1: conflicting values 3 and string (mismatched types int and string):
    ./example.json:1:13
    ../../../../../../nix/store/v64dzx3vr3glpk0cq4hzmh450lrwh6sg-schema.cue:5:11
```

**Known limitations**

* The script will enforce **concrete** values and will not accept lossy transformations (strictness). You can add these options if you need them.
