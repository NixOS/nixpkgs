{
  lib,
  stdenv,
  fetchurl,
  unzip,
  # Renamed from 'jdk' to avoid callPackage auto-injecting pkgs.jdk.
  # If grailsJdk is null, require JAVA_HOME in runtime environment,
  # else store JAVA_HOME=${grailsJdk.home} into grails.
  grailsJdk ? null,
  coreutils,
  ncurses,
  gnused,
  gnugrep, # for purity
}:

let
  binpath = lib.makeBinPath (
    [
      coreutils
      ncurses
      gnused
      gnugrep
    ]
    ++ lib.optional (grailsJdk != null) grailsJdk
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "grails";
  version = "7.0.0-M3";

  src = fetchurl {
    url = "https://github.com/grails/grails-core/releases/download/v${finalAttrs.version}/grails-${finalAttrs.version}.zip";
    hash = "sha256-BM3fxmf86o+Ob63bE9aSCBh2MlkIS4AsYj7CZr/PVWU=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"
    cp -vr . "$out"
    # Remove (for now) uneeded Windows .bat files
    rm -f "$out"/bin/*.bat
    # Improve purity
    sed -i -e '2iPATH=${binpath}:\$PATH' "$out"/bin/grails
  ''
  + lib.optionalString (grailsJdk != null) ''
    # Inject JDK path into grails
    sed -i -e '2iJAVA_HOME=${grailsJdk.home}' "$out"/bin/grails
  '';

  preferLocalBuild = true;

  meta = {
    description = "Full stack, web application framework for the JVM";
    mainProgram = "grails";
    longDescription = ''
      Grails is an Open Source, full stack, web application framework for the
      JVM. It takes advantage of the Groovy programming language and convention
      over configuration to provide a productive and stream-lined development
      experience.
    '';
    homepage = "https://grails.org/";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
