{
  lib,
  buildGoModule,
  fetchFromGitHub,
  python3,
  bash,
  coreutils,
}:

buildGoModule rec {
  pname = "supercronic";
<<<<<<< HEAD
  version = "0.2.40";
=======
  version = "0.2.39";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-20L2GriC+f6bUiJOiUsnvpTEG1J3hp60ry3fSrJt87A=";
  };

  vendorHash = "sha256-a1W/Ah3zPMLvYfQj6uWsHvwjxpLs2vb8E2YYH/RRQvs=";
=======
    hash = "sha256-yAIn5f/ci3oJV55Q8Fd9YrNPI7Cs5yKbnE71Cak9p3I=";
  };

  vendorHash = "sha256-lIFEF0A2JI96ixLLgbOAnGjxXwm39P4SCbKdsVVxC+0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  excludedPackages = [ "cronexpr/cronexpr" ];

  nativeCheckInputs = [
    python3
    bash
    coreutils
  ];

  postConfigure = ''
    # There are tests that set the shell to various paths
    substituteInPlace cron/cron_test.go --replace /bin/sh ${bash}/bin/sh
    substituteInPlace cron/cron_test.go --replace /bin/false ${coreutils}/bin/false
  '';

  ldflags = [ "-X main.Version=${version}" ];

<<<<<<< HEAD
  meta = {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nasageek ];
=======
  meta = with lib; {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = licenses.mit;
    maintainers = with maintainers; [ nasageek ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "supercronic";
  };
}
