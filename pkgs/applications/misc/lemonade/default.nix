{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lemonade";
  version = "unstable-2021-06-18";

  src = fetchFromGitHub {
    owner = "lemonade-command";
    repo = pname;
    rev = "97ad2f7d63cbe6c696af36a754d399b4be4553bc";
    sha256 = "sha256-77ymkpO/0DE4+m8fnpXGdnLLFxWMnKu2zsqCpQ3wEPM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/lemonade-command/lemonade/commit/2b292b0c9d8dc57f73c30a58b3f0f790a953b212.patch";
      sha256 = "sha256-jUcOfsKu1IYa7arZuAvhuD0vw7JTmhzA/VLxOtAnbmI=";
    })
  ];

  vendorHash = "sha256-wjQfTKVNmehu4aU5425gS0YWKj53dosVSTLgdu9KjKc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Remote utility tool that to copy, paste and open browsers over TCP";
    homepage = "https://github.com/lemonade-command/lemonade/";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "lemonade";
  };
}
