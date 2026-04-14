{
  lib,
  stdenv,
  fetchFromGitLab,
  tcl,
  tk,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-base";
  version = "2604.1";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "base";
    rev = finalAttrs.version;
    hash = "sha256-fvElyS3udWurzpI3XZkFJUu4GFc6pJLA7h0KZfp9eJI=";
  };

  buildInputs = [ tcl tk ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/config $out/etc $out/share $out/bin
    cp -r config/* $out/config/
    cp -r etc/*    $out/etc/
    cp -r share/*  $out/share/
    cp -r bin/*    $out/bin/
    substituteInPlace $out/config/buildSettings.mk \
      --replace-fail 'MKDIR   ?= /bin/mkdir' 'MKDIR   ?= mkdir' \
      --replace-fail 'RM      ?= /bin/rm'    'RM      ?= rm'    \
      --replace-fail 'CP      ?= /bin/cp'    'CP      ?= cp'    \
      --replace-fail 'MV      ?= /bin/mv'    'MV      ?= mv'    \
      --replace-fail 'CHMOD   ?= /bin/chmod' 'CHMOD   ?= chmod'
    sed -i "s|\''${FSLDIR}/bin/wish|${tk}/bin/wish|g"   $out/bin/fslwish
    sed -i "s|\''${FSLDIR}/bin/tclsh|${tcl}/bin/tclsh|g" $out/bin/fsltclsh
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FSL base configuration and Makefile infrastructure";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/base";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
