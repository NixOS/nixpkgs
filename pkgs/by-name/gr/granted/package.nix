{
  bash,
  buildGoModule,
  fetchFromGitHub,

  withFish ? false,
  fish,

  lib,
  makeWrapper,
  xdg-utils,
}:

buildGoModule rec {
  pname = "granted";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iNGagF4+Lz73Ctvh8Qs90E+xvuGi7LWHV/VbjjqMqRY=";
  };

  vendorHash = "sha256-uKzs+plk1W2S7iPv2J1Mi1Ff88+82zrIXLy2eTzD/Hc=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/common-fate/granted/internal/build.Version=v${version}"
    "-X github.com/common-fate/granted/internal/build.Commit=${src.rev}"
    "-X github.com/common-fate/granted/internal/build.Date=1970-01-01-00:00:01"
    "-X github.com/common-fate/granted/internal/build.BuiltBy=Nix"
  ];

  subPackages = [
    "cmd/granted"
  ];

  postInstall =
    let
      # assume depends on assumego, so we add (placeholder "out") to its path
      addToAssumePath = lib.makeBinPath [
        xdg-utils
        (placeholder "out")
      ];
    in
    ''
      ln -s $out/bin/granted $out/bin/assumego

      # Create script with correct permissions
      install -Dm755 /dev/null $out/bin/assume

      # assume is a script that must be sourced
      # We can't wrap it because it inspects $0 and calls return, which can only
      # be done in sourced scripts.
      # So instead we insert the following snippet into the beginning of the
      # script to add to PATH.
      # This is borrowed from wrapProgram --suffix PATH :
      addToPath="$(cat << 'EOF'

      PATH=''${PATH:+':'$PATH':'}
      if [[ $PATH != *':'''${addToAssumePath}''':'* ]]; then
          PATH=$PATH'${addToAssumePath}'
      fi
      PATH=''${PATH#':'}
      PATH=''${PATH%':'}
      export PATH

      EOF
      )"

      # Insert below the #!/bin/sh shebang
      echo "$addToPath" | sed "/#!\/bin\/sh/r /dev/stdin" $src/scripts/assume >> $out/bin/assume
    ''
    + lib.optionalString withFish ''
      # Install fish script
      install -Dm755 $src/scripts/assume.fish $out/share/assume.fish
      substituteInPlace $out/share/assume.fish \
        --replace /bin/fish ${fish}/bin/fish
    '';

  meta = with lib; {
    description = "Easiest way to access your cloud";
    homepage = "https://github.com/common-fate/granted";
    changelog = "https://github.com/common-fate/granted/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
