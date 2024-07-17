{
  writeShellApplication,

  monado,
  opencomposite,
}:
writeShellApplication {
  name = "opencomposite-helper";
  text = ''
    # Tell Proton to use OpenComposite instead of OpenVR
    export VR_OVERRIDE=${opencomposite}/lib/opencomposite
    # Help OpenComposite find the OpenXR runtime
    export XR_RUNTIME_JSON=${monado}/share/openxr/1/openxr_monado.json
    # Tell Steam Pressure Vessel to allow access to Monado
    export PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc
    exec "$@"
  '';
}
