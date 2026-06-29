{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  nix-update-script,
}:

buildGo126Module rec {
  pname = "epoch";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sj14";
    repo = "epoch";
    rev = "v${version}";
    hash = "sha256-ENoHwWjFxIZj706o1jMZTBXhMOZnAUw3Owc485sxT88=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  subPackages = [ "cmd/epoch" ];

  vendorHash = null;

  env.CGO_ENABLED = 0;

  # Otherwise, setting '__structuredAttrs = true' leads to:
  #   error: output '/nix/store/jhs5w4qpahxgiflw29bg2cv9szvscpz3-epoch-0.2.3' is not allowed to refer to the following paths:
  #          /nix/store/alxi5gr6vva9nk9ls68m4kvvcx5hvxfi-go-1.26.2
  allowGoReference = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=$(cat COMMIT)"
    "-X main.date=$(cat SOURCE_DATE)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/sj14/epoch";
    description = "Easily convert epoch timestamps to human readable formats and vice versa";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ sj14 ];
  };
}
