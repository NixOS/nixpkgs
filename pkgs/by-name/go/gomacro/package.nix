{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomacro";
  version = "2.7-unstable-2024-01-07";

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "gomacro";
    rev = "bf232d031933810d4a5382e17ce6c4b042a24304";
    hash = "sha256-16u3eByFmnY12M2CEhSJKLIT0KP9nbvTv+BnqWwNTcg=";
  };

  vendorHash = "sha256-ok71QlBHGasGVt+CGwGqhgmx5JLkQcdlU/KX+W1A5Ws=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive Go interpreter and debugger with generics and macros";
    mainProgram = "gomacro";
    homepage = "https://github.com/cosmos72/gomacro";
    license = licenses.mpl20;
    maintainers = with maintainers; [ shofius ];
  };
}
