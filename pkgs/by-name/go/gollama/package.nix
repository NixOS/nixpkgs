{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.27.17";
  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    rev = "v${version}";
    hash = "sha256-/KemOJwVHdb2BJnV53EVvbuE+0s3WOj4kzcox8hRZ6w="; # Replace with actual hash after first build attempt
  };

  vendorHash = "sha256-MbadjPW9Oq3lRVa+Qcq4GXaZnBL0n6qLh5I2hJ0XhaY="; # Replace with actual hash after first build attempt

  # Set CI environment variable to skip tests that require Docker
  doCheck = false;
  preBuild = ''
    export CI=1
  '';

  meta = with lib; {
    description = "A tool for managing Ollama models";
    homepage = "https://github.com/sammcj/gollama";
    license = licenses.mit;
    maintainers = with maintainers; [ adriangl ];
    mainProgram = "gollama";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
