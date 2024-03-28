{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "dnss";
  version = "0-unstable-2023-10-22";
  src = fetchFromGitHub {
    owner = "albertito";
    repo = "dnss";
    rev = "bf9ef4d0789636be69ecaf23a198514c2e636df4";
    hash = "sha256-TTmSS0pHO95YFcVOG9JwrE0i6wJbUbbBQWquTgF9hYg=";
  };

  vendorHash = "sha256-i3LMaaSRTpGjo9VckjAH5RlsOtddm8Y4zqlwmslyZWI=";

  meta = with lib; {
    description = "A daemon for using DNS over HTTPS";
    homepage = "https://blitiri.com.ar/git/r/dnss/";
    license = licenses.asl20;
    mainProgram = "dnss";
    maintainers = with maintainers; [ raspher ];
  };
}
