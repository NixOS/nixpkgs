{
  lib,
  stdenv,
  zig,
  libyuv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "backlight-auto";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "lf94";
    repo = "backlight-auto";
    rev = finalAttrs.version;
    hash = "sha256-QPymwlDrgKM/SXDzJdmfzWLSLU2D7egif1OIUE+SHoI=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = [
    libyuv
  ];

  meta = with lib; {
    description = "Automatically set screen brightness with a webcam";
    mainProgram = "backlight-auto";
    homepage = "https://len.falken.directory/backlight-auto.html";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
