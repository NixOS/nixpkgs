#Copied from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=fakecam-cli
{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec{
  pname = "fakecam-cli";
  version = "0.0"; #not a typo
  src = fetchFromGitHub {
    owner = "UQuark0";
    repo = pname;
    rev = "v${version}";
    sha256 = "pBsjjomQEoqL8tXgh981A/fnlu/TYW/LrDBSzbxAm5Q=";
  };
  vendorSha256 = "ZQqvEsd2sRaAFo1lGVMJZ49CjQj4HLeLPbDCLY8yj8o=";
  GOFLAGS = "-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw -v";
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
