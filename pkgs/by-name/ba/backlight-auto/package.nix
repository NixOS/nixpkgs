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
    # Does not support zig 0.12 or newer, hasn't been updated in 2 years.
    broken = lib.versionAtLeast zig.version "0.12";
    description = "Automatically set screen brightness with a webcam";
    mainProgram = "backlight-auto";
    homepage = "https://len.falken.directory/backlight-auto.html";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
