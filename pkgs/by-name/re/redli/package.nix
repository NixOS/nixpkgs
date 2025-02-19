{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "redli";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BbhjelDY8z4ME2zzataMfDGyice0XZSb1r3wCLxspks=";
  };

  vendorHash = "sha256-6zCkor/fQXKw2JxOKyVjsdsSI6BT7beAs4P0AlSXupE=";

  meta = with lib; {
    description = "Humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
    mainProgram = "redli";
  };
}
