{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sd8vrx7nak0by4whdmd9jzr66zm48knv1w1aqi90709fv98brm9";
  };

  modSha256 = "1nqnjpkrjbb75yfbzh3v3vc4xy5a2aqm9jr40hwq589a4l9p5pw2";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  # As per https://github.com/wtfutil/wtf/issues/501, one of the
  # dependencies can't be fetched, so vendored dependencies should
  # be used instead
  modBuildPhase = ''
    runHook preBuild
    make build -mod=vendor
    runHook postBuild
  '';

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
