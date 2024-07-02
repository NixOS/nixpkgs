{ buildGoModule
, fetchFromGitHub
, lib
, libsodium
, pkg-config
}:

buildGoModule rec {
  pname = "museum";
  version = "0-unstable-2024-03-02";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = "44eb8353a289710ad7dc35a4abfa93feecfe40ac";
    hash = "sha256-IZZ9cxpV55i8AA1POuidAZ7HjhXlr+xwKD/OqOeVpLk=";
  };
  sourceRoot = "${src.name}/server";

  postPatch = ''
    # otherwise go wants us to run "go mod tidy"
    substituteInPlace go.mod \
      --replace-fail "go 1.20" "go 1.21"
  '';

  # "go: inconsistent vendoring in /build/source/server"
  proxyVendor = true;
  vendorHash = "sha256-/1F7ClVQOKDxSauyMHS4EyoTh/3mAcULLrPzDfArNM4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsodium ];

  # fatal: "Not running tests in non-test environment"
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/museum
    cp -R configurations \
      migrations \
      mail-templates \
      $out/share/museum
  '';

  meta = with lib; {
    description = "API server for ente.io";
    homepage = "https://github.com/ente-io/ente/tree/main/server";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ surfaceflinger ];
    mainProgram = "museum";
    platforms = platforms.linux;
  };
}
