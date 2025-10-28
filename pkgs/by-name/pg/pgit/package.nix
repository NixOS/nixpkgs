{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  git, # for passthru tests
  pgit, # for passthru tests
}:

buildGoModule (finalAttrs: {
  pname = "pgit";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "picosh";
    repo = "pgit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-81ZiaY973+mGnYbDX+6fhe9NTYjQhWsvdpW0v42pasw=";
  };

  vendorHash = "sha256-in8GVcOlGsvmcbegJmYwvE0AVJhVJ83x1v3ymV0uTpg=";

  passthru.tests.smoke =
    runCommand "pgit-smoke-test"
      {
        buildInputs = [ git ];
      }
      ''
        ${lib.getExe git} init -b smoke
        ${lib.getExe git} config --local user.name "Nick Spackages"
        ${lib.getExe git} config --local user.email "nixbld@localhost"
        echo "Read me please" > README
        ${lib.getExe git} add README
        ${lib.getExe git} commit -m "First commit"
        ${lib.getExe pgit} -desc "The description" -revs smoke -repo . -out ./public
        grep "The description" ./public/index.html
        grep "First commit" ./public/logs/smoke/index.html
        grep "Read me please" ./public/tree/smoke/item/README.html
        touch $out
      '';

  meta = with lib; {
    description = "static site generator for git";
    homepage = "https://pgit.pico.sh/";
    license = licenses.mit;
    mainProgram = "pgit";
    maintainers = with maintainers; [ jaculabilis ];
  };
})
