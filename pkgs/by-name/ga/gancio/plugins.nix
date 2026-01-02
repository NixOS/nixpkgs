{ callPackage, nodejs }:
{
  telegram-bridge = callPackage ./plugin-telegram-bridge { inherit nodejs; };
}
