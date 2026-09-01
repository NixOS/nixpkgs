# Source-tree workarounds so IntelliJ 2026.2 compiles with kotlin-dist-for-ide
# 2.4.20-ij262-34 (nixpkgs Kotlin 2.2.20 cannot compile this tree).
# Sourced from postPatch so stdenv's substituteInPlace is available.
set -euo pipefail

: "${KOTLIN_IDE_NEW:?KOTLIN_IDE_NEW is required}"
: "${COMPOSE_COMPILER_PLUGIN:?COMPOSE_COMPILER_PLUGIN is required}"

# Nixpkgs Kotlin 2.2.20 does not support JVM 25.
find . -type f -name '*.iml' -exec sed -i \
  -e 's/arg="25"/arg="24"/g' \
  -e 's/JVM 25/JVM 24/g' \
  -e 's/JVM \[25\]/JVM \[24\]/g' \
  {} +
find . -type f -name '*.xml' -exec sed -i \
  -e 's/jvmTarget="25"/jvmTarget="24"/g' \
  -e 's/value="25"/value="24"/g' \
  {} +

# Kotlin 2.2.20 compiler crash on 0.toUShort().
find platform/eel -name EelProxyImpl.kt -exec sed -i \
  's/acceptorPort == 0\.toUShort()/acceptorPort\.toInt() == 0/g' {} +

# Exhaustiveness-check bug.
find platform/eel-nioFs -name EelPathTransfer.kt -exec sed -i \
  's/is DiffOperation.ReplaceFile -> diffOp.sourceFile/is DiffOperation.ReplaceFile -> diffOp.sourceFile\n                  else -> error("unreachable")/g' {} +

# Visibility exposure error.
substituteInPlace platform/util/src/com/intellij/util/concurrency/ContextCallable.java \
  --replace-fail 'final class ContextCallable' 'public final class ContextCallable'
substituteInPlace platform/util/multiplatform/src/com/intellij/util/JavaVersionShim.kt \
  --replace-fail \
  'internal fun currentJavaVersionPlatformSpecific(): JavaVersion = linkToActual()' \
  'internal fun currentJavaVersionPlatformSpecific(): JavaVersion = DefaultJavaVersion'

# Point iml files at the store path of compose-compiler-plugin-for-ide.
find . -type f -name '*.iml' -exec sed -i \
  "s|\\\$KOTLIN_COMPOSE_COMPILER_PLUGIN\\\$|${COMPOSE_COMPILER_PLUGIN}|g" {} +

# Kotlin compiler crash on Int.MAX_VALUE.toUInt().
find platform/eel-impl-base -name EelReadFileImpl.kt -exec sed -i \
  's/Int.MAX_VALUE.toUInt()/2147483647U/g' {} +

# Kotlin 2.4.20-dev adds type annotations that make javac resolve these APIs.
substituteInPlace platform/core-api/intellij.platform.core.iml \
  --replace-fail \
  '<orderEntry type="module" module-name="intellij.libraries.kotlinx.collections.immutable" />' \
  '<orderEntry type="module" module-name="intellij.libraries.kotlinx.collections.immutable" exported="" />'
substituteInPlace python/python-sdk/intellij.python.sdk.iml \
  --replace-fail \
  '<orderEntry type="module" module-name="intellij.libraries.caffeine" />' \
  '<orderEntry type="module" module-name="intellij.libraries.caffeine" exported="" />'
substituteInPlace platform/external-system-impl/intellij.platform.externalSystem.impl.iml \
  --replace-fail \
  '<orderEntry type="module" module-name="intellij.platform.ide.core" />' \
  '<orderEntry type="module" module-name="intellij.platform.ide.core" exported="" />'
substituteInPlace fleet/multiplatform.shims/fleet.multiplatform.shims.iml \
  --replace-fail \
  '<orderEntry type="module" module-name="fleet.util.multiplatform" scope="PROVIDED" />' \
  '<orderEntry type="module" module-name="fleet.util.multiplatform" />'

substituteInPlace \
  plugins/kotlin/jvm-debugger/base/util/src/org/jetbrains/kotlin/idea/debugger/base/util/ClassNameCalculator.kt \
  --replace-fail \
  'package org.jetbrains.kotlin.idea.debugger.base.util' \
  $'@file:Suppress("DEPRECATION_ERROR")\n\npackage org.jetbrains.kotlin.idea.debugger.base.util'

find plugins/gradle/tooling-extension-impl -name GradleModelControllerImpl.kt -exec sed -i \
  's/modelParameter\.parameterClass, modelParameter\.parameterInitializer/modelParameter.parameterClass as Class<Any>, modelParameter.parameterInitializer as Action<in Any>/g' {} +

# sun.swing.text.GlyphViewAccessor is inaccessible on JDK 24+.
cat >platform/util/ui/src/com/intellij/util/ui/html/GlyphViewFix.kt <<'EOF'
package com.intellij.util.ui.html
internal object GlyphViewFix {
  fun init() {}
}
EOF

# kotlinx.coroutines.debug.internal.SUSPENDED is no longer accessible.
substituteInPlace platform/util/base/src/com/intellij/diagnostic/coroutineDumper.kt \
  --replace-fail 'import kotlinx.coroutines.debug.internal.SUSPENDED' ''
substituteInPlace platform/util/base/src/com/intellij/diagnostic/coroutineDumper.kt \
  --replace-fail 'info.state == SUSPENDED' 'info.state == "SUSPENDED"'

# KotlinBinaries.loadKotlinJpsPluginToClassPath checks this against the jar version.
substituteInPlace .idea/kotlinc.xml \
  --replace-fail 'value="2.4.0"' "value=\"${KOTLIN_IDE_NEW}\""

# Library XML still has sha256 of the 2.3.20 artefacts after the version bump.
substituteInPlace .idea/libraries/kotlinc_kotlin_jps_plugin_classpath.xml \
  --replace-fail \
  '0d6103ec6a0eb9c36e856c04d3478099ab86437dd5f19a22a69d9e80b4cff2cb' \
  'a39474812cda48e90ae28981c4d7fd02c9c3e9b3ac0124b8d7a7dbaaa3803e61'
substituteInPlace .idea/libraries/kotlinc_kotlin_jps_plugin_tests.xml \
  --replace-fail \
  'fb351eeb8e11fae3096c43241611f686e8d1940d0f3b6ba6befe71ef908426ce' \
  '12192a1db3fc2f452b7aaa458fe8e7f92121d78fe19ba3741d557276a46206b6'
substituteInPlace .idea/libraries/kotlinc_kotlin_dist.xml \
  --replace-fail \
  '74eabb16163c4575b5dc4b2038268026f389849200f466870714342ccc3792d3' \
  '8334ecdb6a6cd849bd4a9d25f3910c8ee16b2f3e40bb15c2c5707925031c44e2'

# Bypass expects compiler plugin: bind common expect functions to JVM actuals.
sed -i 's/.*fun <K, V> MultiplatformConcurrentHashMap().*/fun <K, V> MultiplatformConcurrentHashMap(): MultiplatformConcurrentHashMap<K, V> = MultiplatformConcurrentHashMapJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/MultiplatformConcurrentHashMap.kt
sed -i 's/.*fun <T> MultiplatformConcurrentHashSet().*/fun <T> MultiplatformConcurrentHashSet(): MultiplatformConcurrentHashSet<T> = MultiplatformConcurrentHashSetJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/MultiplatformConcurrentHashSet.kt
sed -i 's/.*fun threadLocalImpl.*/internal fun threadLocalImpl(supplier: () -> Any?): ThreadLocal<Any?> = threadLocalImplJvm(supplier)/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/ThreadLocal.kt
sed -i 's/internal inline fun synchronizedImplJvm/inline fun synchronizedImplJvm/g' \
  fleet/multiplatform.shims/srcJvmMain/fleet/multiplatform/shims/Synchronized.jvm.kt
sed -i '/fun synchronizedImpl/ s/.*/inline fun synchronizedImpl(lock: SynchronizedObject, block: () -> Any?): Any? = synchronizedImplJvm(lock, block)/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/Synchronized.kt
sed -i '/fun SynchronizedObject()/ s/.*/fun SynchronizedObject(): SynchronizedObject = SynchronizedObjectJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/Synchronized.kt
sed -i '/fun currentThreadId/ s/.*/fun currentThreadId(): Long = currentThreadIdJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/CurrentThread.kt
sed -i '/fun currentThreadName/ s/.*/fun currentThreadName(): String = currentThreadNameJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/CurrentThread.kt
sed -i 's/.*fun DispatchersIO().*/internal fun DispatchersIO(): CoroutineDispatcher = DispatchersIOJvm()/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/DispatchersIO.kt
sed -i 's/.*fun runInterruptibleImpl.*/suspend fun runInterruptibleImpl(context: CoroutineContext, block: () -> Any?): Any? = runInterruptibleImplJvm(context, block)/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/RunInterruptible.kt
sed -i 's/= linkToActual()/= newSingleThreadCoroutineDispatcherJvm(name, priority)/' \
  fleet/multiplatform.shims/srcCommonMain/fleet/multiplatform/shims/SingleThreadCoroutineDispatcher.kt
sed -i 's/.*fun getLoggerFactory().*/internal fun getLoggerFactory(): KLoggerFactory = getLoggerFactoryJvm()/' \
  fleet/util/logging/api/srcCommonMain/fleet/util/logging/KLoggers.kt
sed -i '/fun String.capitalizeWithCurrentLocale/ s/.*/fun String.capitalizeWithCurrentLocale(): String = capitalizeWithCurrentLocaleJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/String.kt
sed -i '/fun String.lowercaseWithCurrentLocale/ s/.*/fun String.lowercaseWithCurrentLocale(): String = lowercaseWithCurrentLocaleJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/String.kt
sed -i '/fun String.uppercaseWithCurrentLocale/ s/.*/fun String.uppercaseWithCurrentLocale(): String = uppercaseWithCurrentLocaleJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/String.kt
sed -i '/fun String.isValidUriString/ s/.*/fun String.isValidUriString(): Boolean = isValidUriStringJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/String.kt
sed -i '/fun getName()/ s/.*/internal fun getName(): String = getNameJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/Os.kt
sed -i '/fun getVersion()/ s/.*/internal fun getVersion(): String = getVersionJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/Os.kt
sed -i '/fun getArch()/ s/.*/internal fun getArch(): String = getArchJvm()/' \
  fleet/util/core/srcCommonMain/fleet/util/Os.kt
sed -i '/fun codepointsToString/ s/.*/internal fun codepointsToString(vararg codepoints: Int): String = codepointsToStringJvm(*codepoints)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun codepointOf/ s/.*/internal fun codepointOf(highSurrogate: Char, lowSurrogate: Char): Codepoint = codepointOfJvm(highSurrogate, lowSurrogate)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun highSurrogate/ s/.*/internal fun highSurrogate(codepoint: Int): Char = highSurrogateJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun lowSurrogate/ s/.*/internal fun lowSurrogate(codepoint: Int): Char = lowSurrogateJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isLetter(/ s/.*/internal fun isLetter(codepoint: Int): Boolean = isLetterJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isDigit(/ s/.*/internal fun isDigit(codepoint: Int): Boolean = isDigitJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isLetterOrDigit(/ s/.*/internal fun isLetterOrDigit(codepoint: Int): Boolean = isLetterOrDigitJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isUpperCase(/ s/.*/internal fun isUpperCase(codepoint: Int): Boolean = isUpperCaseJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isLowerCase(/ s/.*/internal fun isLowerCase(codepoint: Int): Boolean = isLowerCaseJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun toLowerCase(/ s/.*/internal fun toLowerCase(codepoint: Int): Int = toLowerCaseJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun toUpperCase(/ s/.*/internal fun toUpperCase(codepoint: Int): Int = toUpperCaseJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isSpaceChar(/ s/.*/internal fun isSpaceChar(codepoint: Int): Boolean = isSpaceCharJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isWhitespace(/ s/.*/internal fun isWhitespace(codepoint: Int): Boolean = isWhitespaceJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isIdeographic(/ s/.*/internal fun isIdeographic(codepoint: Int): Boolean = isIdeographicJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isIdentifierIgnorable(/ s/.*/internal fun isIdentifierIgnorable(codepoint: Int): Boolean = isIdentifierIgnorableJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isUnicodeIdentifierStart(/ s/.*/internal fun isUnicodeIdentifierStart(codepoint: Int): Boolean = isUnicodeIdentifierStartJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isUnicodeIdentifierPart(/ s/.*/internal fun isUnicodeIdentifierPart(codepoint: Int): Boolean = isUnicodeIdentifierPartJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isJavaIdentifierStart(/ s/.*/internal fun isJavaIdentifierStart(codepoint: Int): Boolean = isJavaIdentifierStartJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isJavaIdentifierPart(/ s/.*/internal fun isJavaIdentifierPart(codepoint: Int): Boolean = isJavaIdentifierPartJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun isISOControl(/ s/.*/internal fun isISOControl(codepoint: Int): Boolean = isISOControlJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt
sed -i '/fun getUnicodeScript(/ s/.*/internal fun getUnicodeScript(codepoint: Int): UnicodeScript = getUnicodeScriptJvm(codepoint)/' \
  fleet/util/codepoints/srcCommonMain/fleet/codepoints/CodepointFunctions.kt

sed -i 's/.*fun <T> threadLocalImpl.*/internal fun <T> threadLocalImpl(supplier: () -> T): ThreadLocalKmp<T> = threadLocalImplJvm(supplier)/' \
  platform/util/multiplatform/src/com/intellij/util/ThreadLocalKmp.kt
sed -i 's/= linkToActual()/= currentJavaVersionPlatformSpecificJvm()/' \
  platform/util/multiplatform/src/com/intellij/util/JavaVersionShim.kt
sed -i 's/.*fun getCharsPlatformSpecific.*/internal fun getCharsPlatformSpecific(sequence: CharSequence, srcOffset: Int, dst: CharArray, dstOffset: Int, len: Int): Boolean = getCharsPlatformSpecificJvm(sequence, srcOffset, dst, dstOffset, len)/' \
  platform/util/base/multiplatform/src/com/intellij/util/text/CharArrayUtilKmp.kt
sed -i 's/.*fun fromSequenceWithoutCopyingPlatformSpecific.*/internal fun fromSequenceWithoutCopyingPlatformSpecific(seq: CharSequence?): CharArray? = fromSequenceWithoutCopyingPlatformSpecificJvm(seq)/' \
  platform/util/base/multiplatform/src/com/intellij/util/text/CharArrayUtilKmp.kt
sed -i 's/.*fun <K : Any, V : Any> newConcurrentMap.*/internal fun <K : Any, V : Any> newConcurrentMap(): MultiplatformConcurrentMap<K, V> = newConcurrentMapJvm()/' \
  platform/syntax/syntax-extensions/src/com/intellij/platform/syntax/extensions/impl/CollectionsImpl.kt
sed -i 's/.*fun <V : Any> newConcurrentSet.*/internal fun <V : Any> newConcurrentSet(): MutableSet<V> = newConcurrentSetJvm()/' \
  platform/syntax/syntax-extensions/src/com/intellij/platform/syntax/extensions/impl/CollectionsImpl.kt
sed -i 's/.*fun instantiateExtensionRegistry.*/internal fun instantiateExtensionRegistry(): ExtensionSupport = instantiateExtensionRegistryJvm()/' \
  platform/syntax/syntax-extensions/src/com/intellij/platform/syntax/extensions/impl/ExtensionRegistryHolder.kt
sed -i 's/.*fun instantiateThreadLocalRegistry.*/internal fun instantiateThreadLocalRegistry(): RegistryHolder = instantiateThreadLocalRegistryJvm()/' \
  platform/syntax/syntax-extensions/src/com/intellij/platform/syntax/extensions/impl/ExtensionRegistryHolder.kt
sed -i 's/.*fun newChameleonRef().*/fun newChameleonRef(): ChameleonRef = newChameleonRefJvm()/' \
  platform/syntax/syntax-api/src/com/intellij/platform/syntax/tree/ASTMarkers.kt
sed -i 's/.*fun newChameleonRef(chameleon: AstMarkersChameleon).*/fun newChameleonRef(chameleon: AstMarkersChameleon): ChameleonRef = newChameleonRefJvm(chameleon)/' \
  platform/syntax/syntax-api/src/com/intellij/platform/syntax/tree/ASTMarkers.kt
sed -i 's/.*fun makeStackTraceRelative.*/internal fun makeStackTraceRelative(th: Throwable, relativeTo: Throwable): Throwable = makeStackTraceRelativeJvm(th, relativeTo)/' \
  platform/syntax/syntax-api/src/com/intellij/platform/syntax/impl/builder/MarkerProduction.kt
sed -i 's/= linkToActual()/= ResourceBundleJvm(bundleClass, pathToBundle, self, defaultMapping)/' \
  platform/syntax/syntax-i18n/src/com/intellij/platform/syntax/i18n/ResourceBundle.kt

# Dummy RemoteApiDescriptor so listBundledPlugins can resolve local backends
# without the RPC compiler plugin.
sed -i -e '/inline fun <reified T : RemoteApi<\*>> remoteApiDescriptor/,+2c\
inline fun <reified T : RemoteApi<*>> remoteApiDescriptor(descriptor: RemoteApiDescriptor<T>? = null): RemoteApiDescriptor<T> {\
  return descriptor ?: object : RemoteApiDescriptor<T> {\
    override fun getSignature(methodName: String): RpcSignature = error("Not implemented")\
    override fun clientStub(proxy: suspend (String, Array<Any?>) -> Any?): T = error("Not implemented")\
    override fun getApiFqn(): String = T::class.qualifiedName ?: "Unknown"\
    override suspend fun call(impl: T, methodName: String, args: Array<Any?>): Any? = error("Not implemented")\
  }\
}' fleet/rpc/srcCommonMain/fleet/rpc/FleetApi.kt

# JBR.getFontExtensions() is null on non-JBR JDKs.
substituteInPlace platform/platform-impl/src/com/intellij/application/options/colors/FontGlyphHashCache.kt \
  --replace-fail \
  'JBR.getFontExtensions().getEnabledFeatures(f).joinToString(",")' \
  '(JBR.getFontExtensions()?.getEnabledFeatures(f)?.joinToString(",") ?: "")'

# Empty/invalid ZIPs crash ClassFileChecker during the build.
sed -i -e '/if (fullPath.endsWith(".zip") || fullPath.endsWith(".jar")) {/,+2c\
    if (fullPath.endsWith(".zip") || fullPath.endsWith(".jar")) {\
      try { visitZip(zipPath = fullPath, zipRelPath = relativePath, file = ZipFile(FileChannel.open(file, READ)), errors = errors) }\
      catch (e: Exception) { System.err.println("WARN: Failed to read ZIP file: $fullPath: ${e.message}") }\
    }' platform/build-scripts/src/org/jetbrains/intellij/build/impl/ClassFileChecker.kt
