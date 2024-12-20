# Geant4 {#geant4}

[Geant4](https://www.geant4.org/) is a toolkit for simulating how particles pass through matter. It is available through the `geant4` package.

## Setup hook {#geant4-hook}

The setup hook included in the package applies the environment variables set by the [`geant4.sh` script](https://github.com/Geant4/geant4/blob/master/cmake/Modules/G4ConfigureGNUMakeHelpers.cmake#L4-L55), which is typically necessary for compiling `make`-based programs that depend on Geant4.

## Datasets {#geant4-datasets}

All of [the Geant4 datasets provided by CERN](https://geant4.web.cern.ch/support/download) are available through the `geant4.data` attrset.

### Setup hook {#geant4-datasets-hook}

The hook provided by the packages in `geant4.data` will set an appropriate environment variable in the form of `G4[...]DATA`. For example, for the `G4RadioactiveDecay` dataset, the `G4RADIOACTIVEDATA` environment variable is set to the value expected by Geant4.
