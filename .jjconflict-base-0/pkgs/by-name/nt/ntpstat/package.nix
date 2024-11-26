{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ntpstat";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "mlichvar";
    repo = "ntpstat";
    rev = "${finalAttrs.version}";
    hash = "sha256-dw6Pi+aB7uK65H0HL7q1vYnM5Dp0D+kG+ZIaiv8VH5I=";
  };

  postPatch = ''
    patchShebangs ntpstat
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Print the ntpd or chronyd synchronisation status";
    homepage = "https://github.com/mlichvar/ntpstat";
    license = lib.licenses.mit;
    mainProgram = "nptstat";
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.all;
  };
})
