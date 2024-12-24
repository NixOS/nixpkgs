{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "subjs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-csxFn3YUnuYjZ5/4jIi7DfuujB/gFjHogLaV4XK5kQU=";
  };

  vendorHash = "sha256-Ibsgi2MYvs12E1NJgshAD/S5GTJgLl7C+smfvS+aAfg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Fetcher for Javascript files";
    mainProgram = "subjs";
    longDescription = ''
      subjs fetches Javascript files from a list of URLs or subdomains.
      Analyzing Javascript files can help you find undocumented endpoints,
      secrets and more.
    '';
    homepage = "https://github.com/lc/subjs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
