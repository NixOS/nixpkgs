{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "install-fonts-hook";
  meta = {
    description = "Copies standard font extension into their respective installation path";
    maintainers = with lib.maintainers; [
      pancaek
      sigmanificient
      jopejoe1
    ];
    license = lib.licenses.mit;
  };
} ./install-fonts.sh
