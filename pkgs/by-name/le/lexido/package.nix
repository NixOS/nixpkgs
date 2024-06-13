{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lexido";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "micr0-dev";
    repo = "lexido";
    rev = "v${version}";
    hash = "sha256-nc6UvW16MmLsKt0oSb9nG64N7J3+5CveSwPnGOezhGY=";
  };

  vendorHash = "sha256-h3ws9k7W4nNyS1WvZP29NJfJsBOe0D47ykd41C96Xi4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Terminal assistant, powered by Generative AI";
    homepage = "https://github.com/micr0-dev/lexido";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "lexido";
  };
}
