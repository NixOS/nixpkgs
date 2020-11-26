diff --git a/Source/Lua/JuceClasses/LAudio.cpp b/Source/Lua/JuceClasses/LAudio.cpp
index 14749d88..0002de79 100644
--- a/Source/Lua/JuceClasses/LAudio.cpp
+++ b/Source/Lua/JuceClasses/LAudio.cpp
@@ -34,16 +34,6 @@ void LAudioFile::wrapForLua(lua_State *L)
 			.def("isCompressed", &OggVorbisAudioFormat::isCompressed)
 			.def("getQualityOptions", &OggVorbisAudioFormat::getQualityOptions)
 			.def("estimateOggFileQuality", &OggVorbisAudioFormat::estimateOggFileQuality)
-		,
-		class_<FlacAudioFormat>("FlacAudioFormat")
-			.def(constructor<>())
-			.def("canDoStereo", &FlacAudioFormat::canDoStereo)
-			.def("canDoMono", &FlacAudioFormat::canDoMono)
-			.def("canHandleFile", &FlacAudioFormat::canHandleFile)
-			.def("createReaderFor", &FlacAudioFormat::createReaderFor)
-			.def("createWriterFor", &FlacAudioFormat::createWriterFor)
-			.def("isCompressed", &FlacAudioFormat::isCompressed)
-			.def("getQualityOptions", &FlacAudioFormat::getQualityOptions)
 	];
 }
 
