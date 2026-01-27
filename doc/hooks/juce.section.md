# `juce.projucerHook` {#juce-projucer-hook}

[Projucer](https://juce.com/tutorials/tutorial_new_projucer_project/) is a graphical project management utility and build system for the [JUCE](https://juce.com/) audio programming framework. It is available in nixpkgs under the `juce` package.

The `juce.projucerHook` setup hook overrides the configure and install phases. It is only supported on Linux and requires your project's `.jucer` file to contain a `LinuxMakefile` exporter.

## Example {#juce-projucer-hook-example}

```nix
{
  juce,
  stdenv,
}:
stdenv.mkDerivation {
  # ...
  nativeBuildInputs = [ juce.projucerHook ];

  jucerFile = "Microbiome.jucer";

  dontUseProjucerInstall = true;
  # ...
}
```

## Variables controlling `juce.projucerHook` {#juce-projucer-hook-variables}

### `dontUseProjucerConfigure`

Disables `projucerConfigurePhase`

### `dontUseProjucerInstall`

Disables `projucerInstallPhase`
