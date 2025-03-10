addChezLibraryPath() {
  appendToSearchPath CHEZSCHEMELIBDIRS "$1/lib/csv-site"
}

addEnvHooks "$targetOffset" addChezLibraryPath
