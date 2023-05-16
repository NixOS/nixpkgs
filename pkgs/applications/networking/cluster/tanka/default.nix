{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.24.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xKB/SKiw3cKqdpl869Bs/NO1Jbrla8Un0hH4kIGqAPs=";
  };

  vendorHash = "sha256-+BCUQ+czqWkxbDoSvCaAxewTN0SuI+hCHEQpLOvNGj4=";
=======
    sha256 = "sha256-RZLmbf9ginMbFAaUKL5mK5HIYQslP8Vu8zdh1OJ1P1Y=";
  };

  vendorHash = "sha256-g9e0NesI7WdaTHZ57XRlo8as3IWAFlFW4nkyf6+kd40=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/tk" ];

  ldflags = [ "-s" "-w" "-extldflags '-static'" "-X github.com/grafana/tanka/pkg/tanka.CurrentVersion=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    echo "complete -C $out/bin/tk tk" > tk.bash
    installShellCompletion tk.bash
  '';

  meta = with lib; {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    homepage = "https://tanka.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    mainProgram = "tk";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
