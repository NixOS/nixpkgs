{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.40.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-oRDkuYmTR5SvmWJ9/tpW+926ShY3KrsgTiwWjQfeIEg=";
  };

  vendorHash = "sha256-+phwbG2ODhzfzqOJ6IuT/XDzTevPrdOfJH6PKLKeJlM=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  meta = with lib; {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = licenses.asl20;
    maintainers = with maintainers; [ cbrewster ];
    platforms = platforms.unix;
    mainProgram = "hermit";
  };
}
