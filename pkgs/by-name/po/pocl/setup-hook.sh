preCheckHooks+=('setupPoclCheck')
preInstallCheckHooks+=('setupPoclCheck')

setupPoclCheck () {
  export OCL_ICD_VENDORS="@out@/etc/OpenCL/vendors"
}
