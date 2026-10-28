{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsBuildHost,
  versionCheckHook,
}:

# Changing the variables CPPFLAGS and BUILD_CONFIG_NAME can be done by
# overriding the same-named attributes. See ./presets.nix for examples.

stdenv.mkDerivation (finalAttrs: {
  pname = "mkspiffs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "igrr";
    repo = "mkspiffs";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-oa6Lmo2yb66IjtEKkZyJBgM/p7rdvmrKfgNd2rAM/Lk=";
  };

  # 1) Fix build for Darwin
  # 2) Fix cross
  # 3) Do not run test as part of the buildPhase - the checkPhase will run it as `make test`
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-arch i386 -arch x86_64" "" \
      --replace-fail "strip" "${pkgsBuildHost.binutils.targetPrefix}strip" \
      --replace-fail "dist: test" ""
  '';

  strictDeps = true;

  buildFlags = [ "dist" ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "SPIFFS_VERSION=unknown"
  ];

  installPhase = ''
    install -Dm755 -t $out/bin mkspiffs
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool to build and unpack SPIFFS images";
    license = lib.licenses.mit;
    homepage = "https://github.com/igrr/mkspiffs";
    maintainers = [ lib.maintainers.haslersn ];
    platforms = lib.platforms.all;
    mainProgram = "mkspiffs";
  };
})
