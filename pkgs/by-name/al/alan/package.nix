{
  stdenv,
  lib,
  fetchFromGitHub,
  cgreen,
  openjdk,
  pkg-config,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alan";
  version = "3.0beta8";

  src = fetchFromGitHub {
    owner = "alan-if";
    repo = "alan";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-9F99rr7tdkaGPHtD92ecmUxO6xrjQDRhGtSTVbMLz30=";
  };

  postPatch = ''
    patchShebangs --build bin
    # The Makefiles have complex CFLAGS that don't allow separate control of optimization
    sed -i 's/-O0/-O2/g' compiler/Makefile.common
    sed -i 's/-Og/-O2/g' interpreter/Makefile.common
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/alan/examples
    # Build the release tarball
    make package
    # The release tarball isn't split up into subdirectories
    tar -xf alan*.tgz --strip-components=1 -C $out/share/alan
    mv $out/share/alan/*.alan $out/share/alan/examples
    chmod a-x $out/share/alan/examples/*.alan
    mv $out/share/alan/{alan,arun} $out/bin
    # a2a3 isn't included in the release tarball
    cp bin/a2a3 $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [
    cgreen
    openjdk
    pkg-config
    which
  ];

  meta = {
    homepage = "https://www.alanif.se/";
    description = "Alan interactive fiction language";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ neilmayhew ];
  };
})
