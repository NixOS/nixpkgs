{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
  makeWrapper,
  nodejs,
  thruster,
  sqlite,
  vips,
  openssl,
  pkg-config,
  nixosTests,
}:

bundlerApp {
  pname = "fizzy";
  exes = [ "rails" ];

  inherit ruby;

  gemdir = ./.;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    sqlite
    vips
    openssl
  ];

  postBuild = ''
    # Wrap the rails binary to ensure runtime deps are on PATH
    wrapProgram $out/bin/rails \
      --prefix PATH : ${
        lib.makeBinPath [
          thruster
          nodejs
        ]
      } \
      --set RAILS_ENV production \
      --set LD_PRELOAD ""

    # Install the docker-entrypoint equivalent as a helper script
    makeWrapper ${thruster}/bin/thruster $out/bin/fizzy-server \
      --add-flags "$out/bin/rails server" \
      --set RAILS_ENV production
  '';

  passthru = {
    updateScript = bundlerUpdateScript "fizzy";
    tests = lib.optionalAttrs (nixosTests ? fizzy) {
      inherit (nixosTests) fizzy;
    };
  };

  meta = {
    description = "Kanban tracking tool for issues and ideas by 37signals";
    longDescription = ''
      Fizzy is an open-source Kanban tracking tool for issues and ideas,
      originally built and used by 37signals. It supports multi-tenancy,
      SQLite and MySQL, web push notifications (VAPID), and deployment
      via Kamal or Docker.
    '';
    homepage = "https://fizzy.do/";
    changelog = "https://github.com/basecamp/fizzy/releases";
    license = lib.licenses.unfree; # O'Saasy License
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "rails";
  };
}
