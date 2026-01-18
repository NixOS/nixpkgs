{
  stdenv,
  lib,
  fetchurl,
  cmake,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nettee";
  version = "0.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/nettee/nettee-${finalAttrs.version}.tar.gz";
    hash = "sha256-WeZ18CLexdWy8RlHNh0Oo/6KXxzShZT8/xklAWyB8ss=";
  };

  patches = [ ./fix-cmake-output.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8)" "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  # additional shell scripts require accudate (not in nixpkgs)
  postInstall = ''
    rm $out/bin/*.sh
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  meta = {
    homepage = "https://sourceforge.net/projects/nettee";
    description = ''Network "tee" program'';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Profpatsch ];
    platforms = lib.platforms.linux;
    mainProgram = "nettee";
  };
})
