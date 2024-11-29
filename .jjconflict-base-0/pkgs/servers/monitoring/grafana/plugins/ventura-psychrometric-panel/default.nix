{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "ventura-psychrometric-panel";
  version = "4.5.1";
  zipHash = "sha256-Y/Eh3eWZkPS8Q1eha7sEJ3wTMI7QxOr7MEbPc25fnGg=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart.";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
