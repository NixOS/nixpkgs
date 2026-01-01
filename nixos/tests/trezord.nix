{ pkgs, ... }:
{
  name = "trezord";
<<<<<<< HEAD
  meta = {
    maintainers = with pkgs.lib.maintainers; [
=======
  meta = with pkgs.lib; {
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mmahut
      _1000101
    ];
  };
  nodes = {
    machine =
      { ... }:
      {
        services.trezord.enable = true;
        services.trezord.emulator.enable = true;
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("trezord.service")
    machine.wait_for_open_port(21325)
    machine.wait_until_succeeds("curl -fL http://localhost:21325/status/ | grep Version")
  '';
}
