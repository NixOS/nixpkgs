# NixOS manpages

This is the collection of NixOS manpages, excluding `configuration.nix(5)`.

Man pages are written in [`mdoc(7)` format](https://mandoc.bsd.lv/man/mdoc.7.html) and should be portable between mandoc and groff for rendering (though minor differences may occur, mandoc and groff seem to have slightly different spacing rules.)

For previewing edited files, you can just run `man -l path/to/file.8` and you will see it rendered.

Being written in `mdoc` these manpages use semantic markup. This file provides a guideline on where to apply which of the semantic elements of `mdoc`.

### Command lines and arguments

In any manpage, commands, flags and arguments to the *current* executable should be marked according to their semantics. Commands, flags and arguments passed to *other* executables should not be marked like this and should instead be considered as code examples and marked with `Ql`.

 - Use `Fl` to mark flag arguments, `Ar` for their arguments.
 - Repeating arguments should be marked by adding ellipses (`...`).
 - Use `Cm` to mark literal string arguments, e.g. the `boot` command argument passed to `nixos-rebuild`.
 - Optional flags or arguments should be marked with `Op`. This includes optional repeating arguments.
 - Required flags or arguments should not be marked.
 - Mutually exclusive groups of arguments should be enclosed in curly brackets, preferrably created with `Bro`/`Brc` blocks.

When an argument is used in an example it should be marked up with `Ar` again to differentiate it from a constant. For example, a command with a `--host name` flag that calls ssh to retrieve the host's local time would signify this thusly:
```
This will run
.Ic ssh Ar name Ic time
to retrieve the remote time.
```

### Paths, NixOS options, environment variables

Constant paths should be marked with `Pa`, NixOS options with `Va`, and environment variables with `Ev`.

Generated paths, e.g. `result/bin/run-hostname-vm` (where `hostname` is a variable or arguments) should be marked as `Ql` inline literals with their variable components marked appropriately.

 - Taking `hostname` from an argument become `.Ql result/bin/run- Ns Ar hostname Ns -vm`
 - Taking `hostname` from a variable otherwise defined becomes `.Ql result/bin/run- Ns Va hostname Ns -vm`

### Code examples and other commands

In free text names and complete invocations of other commands (e.g. `ssh` or `tar -xvf src.tar`) should be marked with `Ic`, fragments of command lines should be marked with `Ql`.

Larger code blocks or those that cannot be shown inline should use indented literal display block markup for their contents, i.e.
```
.Bd -literal -offset indent
...
.Ed
```
Contents of code blocks may be marked up further, e.g. if they refer to arguments that will be subsituted into them:
```
.Bd -literal -offset indent
{
  options.hostname = "\c
.Ar hostname Ns \c
";
}
.Ed
```
