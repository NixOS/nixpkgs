{
  openbangla-keyboard,
  ...
}@args:

openbangla-keyboard.override (
  {
    withFcitx5Support = true;
    withIbusSupport = false;
  }
  // removeAttrs args [ "openbangla-keyboard" ]
)
