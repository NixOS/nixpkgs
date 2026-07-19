{
  cmake,
  fetchFromGitHub,
  lib,
  libconfuse,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postsrsd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    tag = finalAttrs.version;
    hash = "sha256-3taFk7LEsbk4HmW/llKrjCUTw4upoWpYbVFTHq7Q5t4=";
  };

  cmakeFlags = [
    (lib.cmakeBool "GENERATE_SRS_SECRET" false)
    (lib.cmakeBool "INSTALL_SYSTEMD_SERVICE" false)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libconfuse
  ];

  meta = {
    changelog = "https://github.com/roehling/postsrsd/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    mainProgram = "postsrsd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.hexa ];
  };
})
