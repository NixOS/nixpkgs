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
        ${git.exe} init -b smoke
        ${git.exe} config --local user.name "Nick Spackages"
        ${git.exe} config --local user.email "nixbld@localhost"
        echo "Read me please" > README
        ${git.exe} add README
        ${git.exe} commit -m "First commit"
        ${pgit.exe} -desc "The description" -revs smoke -repo . -out ./public
        grep "The description" ./public/index.html
        grep "First commit" ./public/logs/smoke/index.html
        grep "Read me please" ./public/tree/smoke/item/README.html
        touch $out
      '';

  meta = {
    description = "static site generator for git";
    homepage = "https://pgit.pico.sh/";
    license = lib.licenses.mit;
    mainProgram = "pgit";
    maintainers = with lib.maintainers; [ jaculabilis ];
  };
})
