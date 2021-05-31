#Copied from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=fakecam-gui
{ buildGoModule, fetchFromGitHub, lib, wrapGAppsHook, gtk3, polkit, ffmpeg, pkg-config }:
buildGoModule rec{
  pname = "fakecam-gui";
  version = "0.0"; #not a typo
  src = fetchFromGitHub {
    owner = "UQuark0";
    repo = pname;
    rev = "v${version}";
    sha256 = "SY2/Lx2dFXgY+Nr1Pj8owz41HPVxSx3LmGE8Hi9eTsk=";
  };
  vendorSha256 = "stISOOuaXZGYKaTU7JBpVsk+EZjKFjvjik5Nr3q9nxw=";
  GOFLAGS = "-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw -v";
  nativeBuildInputs = [ wrapGAppsHook pkg-config ];
  buildInputs = [ gtk3 polkit ffmpeg ];
  meta = with lib;{
    description = ''
      A fake webcam provider to stream custom video (CLI)
      You need to add
      boot.extraModprobeConfig = "options v4l2loopback exclusive_caps=1 video_nr=2";
    '';
    license = licenses.mit;
    platform = platforms.linux;
    maintainer = with maintainers;[];
  };
}
