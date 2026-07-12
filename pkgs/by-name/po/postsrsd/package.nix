{
  cmake,
  fetchFromGitHub,
  lib,
  libconfuse,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postsrsd";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    tag = finalAttrs.version;
    hash = "sha256-xBVkhhnLBzCaMFrYze+MdHDJQPJefQdr6jJDTVmN1dU=";
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
