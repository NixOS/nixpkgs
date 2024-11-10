{ lib
, buildGoModule
, fetchFromGitHub
, python3
, bash
, coreutils
}:

buildGoModule rec {
  pname = "supercronic";
  version = "0.2.30";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gey5d+Dxmk7TS0miWRjeWMxW+qYrAPVYGHcHNYrYwK4=";
  };

  vendorHash = "sha256-ebUsnPpvQ/AK3C7MbGnXWSiuoXrjhQ2uZhj1OtRGeWU=";

  excludedPackages = [ "cronexpr/cronexpr" ];

  nativeCheckInputs = [ python3 bash coreutils ];

  postConfigure = ''
    # There are tests that set the shell to various paths
    substituteInPlace cron/cron_test.go --replace /bin/sh ${bash}/bin/sh
    substituteInPlace cron/cron_test.go --replace /bin/false ${coreutils}/bin/false
  '';

  meta = with lib; {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = licenses.mit;
    maintainers = with maintainers; [ nasageek ];
    mainProgram = "supercronic";
  };
}
