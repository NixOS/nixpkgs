{ buildGoModule, fetchFromGitHub, lib, wrapGAppsHook, gtk3, polkit, ffmpeg }:
buildGoModule rec{
  pname = "fakecam-gui";
  version = "0.0"; #not a typo
  src = fetchFromGitHub {
    owner = "UQuark0";
    repo = pname;
    rev = "v${version}";
    sha256 = "pBsjjomQEoqL8tXgh981A/fnlu/TYW/LrDBSzbxAm5Q=";
  };
  vendorSha256 = "ZQqvEsd2sRaAFo1lGVMJZ49CjQj4HLeLPbDCLY8yj8o=";
  GOFLAGS = "-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw -v";
  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ gtk3 polkit ffmpeg ];
  meta = with lib;{
    description = ''
      A fake webcam provider to stream custom video (CLI)
      You need to add
      boot.extraModprobeConfig = "modprobe v4l2loopback exclusive_caps=1 video_nr=2";
    '';
    license = licenses.mit;
    platform = platforms.linux;
    maintainer = with maintainers;[];
  };
}
