### copy-modules-closure

# What?

This program, when passed a set of kernel modules as arguments, computes the closure of these. It then copies all modules from that closure to a new location. That means that all modules that are required for the given ones to work will be contained in the generated closure.
It also copies required firmware and generates an "insmod-list" file, which records the modules in the closure.

# Why?

This is used in NixOS to only include those modules in the initrd that the system actually needs.

# Environment variables:

* out : the output directory for the computed closure
* firmware : the firmware is read from the "lib/firmware" subdir of this directory
* version : the kernel version
* kernel : the modules are read from the "lib/modules/$version" subdir of this directory
* allowMissing (optional): set this variable to allow missing modules in the closure

