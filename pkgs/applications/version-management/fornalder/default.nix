{ lib, rustPlatform, fetchFromGitHub, makeWrapper, gnuplot }:

rustPlatform.buildRustPackage rec {
  pname = "fornalder";
  version = "unstable-2022-12-25";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = pname;
    rev = "3248128fe320d88183d17a65e936092e07d6529b";
    sha256 = "sha256-IPSxVWJs4EhyBdA1NXpD8v3fusewt1ELpn/kbZt7c5Q=";
  };

  cargoHash = "sha256-eK+oQbOQj8pKiOTXzIgRjzVB7Js8MMa9V6cF9D98Ftc=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fornalder \
      --suffix PATH : ${lib.makeBinPath [ gnuplot ]}
  '';

  meta = with lib; {
    description = "Visualize long-term trends in collections of Git repositories";
    homepage = "https://github.com/hpjansson/fornalder";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro figsoda ];
    mainProgram = "fornalder";
  };
}
