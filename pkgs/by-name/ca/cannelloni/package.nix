{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lksctp-tools,
  sctpSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cannelloni";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "mguentner";
    repo = "cannelloni";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dhrB3qg/ljAP7nX+WpX+g7HaUEGj5pTPdDhY2Mi7pUo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals sctpSupport [ lksctp-tools ];

  cmakeFlags = [
    "-DSCTP_SUPPORT=${lib.boolToString sctpSupport}"
  ];

  meta = with lib; {
    description = "SocketCAN over Ethernet tunnel";
    mainProgram = "cannelloni";
    homepage = "https://github.com/mguentner/cannelloni";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.samw ];
  };
})
