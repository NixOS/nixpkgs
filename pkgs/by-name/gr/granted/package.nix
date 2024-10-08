{
  bash,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

  withFish ? false,
  fish,

  lib,
  makeWrapper,
  xdg-utils,
}:

buildGoModule rec {
  pname = "granted";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0zFM7QH2JrYt7zakf1xj3F9D8dhA5/Mk78Jw8CIq48s=";
  };

  vendorHash = "sha256-SfjHzYHJ+iat7pXhs8M8GBfyZy+RKetKnAsA2UhLJuM=";

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
    ''
      ln -s $out/bin/granted $out/bin/assumego

      # Install shell script
      install -Dm755 $src/scripts/assume $out/bin/assume
      substituteInPlace $out/bin/assume \
        --replace /bin/bash ${bash}/bin/bash

      wrapProgram $out/bin/assume \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    ''
    + lib.optionalString withFish ''
      # Install fish script
      install -Dm755 $src/scripts/assume.fish $out/share/assume.fish
      substituteInPlace $out/share/assume.fish \
        --replace /bin/fish ${fish}/bin/fish
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Easiest way to access your cloud";
    homepage = "https://github.com/common-fate/granted";
    changelog = "https://github.com/common-fate/granted/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jlbribeiro
    ];
  };
}
