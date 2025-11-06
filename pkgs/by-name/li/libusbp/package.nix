{
  lib,
  stdenv,
  fetchFromGitHub,
  udev,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libusbp";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "pololu";
    repo = "libusbp";
    rev = finalAttrs.version;
    hash = "sha256-hFvQceUapzlD021KIOJbSXX7qv1IQMuEudRHYeCkbS8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    udev
  ];

  meta = with lib; {
    homepage = "https://github.com/pololu/libusbp";
    changelog = "https://github.com/pololu/libusbp/blob/${finalAttrs.src.rev}/README.md#version-history";
    description = "Pololu USB Library (also known as libusbp)";
    longDescription = ''
      libusbp is a cross-platform C library for accessing USB devices
    '';
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ bzizou ];
  };
})
