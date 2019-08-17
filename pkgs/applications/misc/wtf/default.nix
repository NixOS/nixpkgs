{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "19qzg5blqm5p7rrnaqh4f9aj53i743mawjnd1h9lfahbgmil1d24";
  };

  modSha256 = "1q21pc4yyiq4dihsb9n7261ssj52nnik8dq6fg4gvlnnpgcjp570";

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
