# Whether cc-wrapper takes its GNU runtime from gccForLibs. Keep this policy
# usable with wrappers from other package sets that do not expose the result.
{
  useCcForLibs,
  libcxx,
  gccForLibs,
  targetPlatform,
  ...
}:
useCcForLibs
&& libcxx == null
&& !targetPlatform.isDarwin
&& !(targetPlatform.useLLVM or false)
&& !(targetPlatform.useAndroidPrebuilt or false)
&& !(targetPlatform.isiOS or false)
&& gccForLibs != null
