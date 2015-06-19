{ grobidTempPath, grobidNativeLibsPath, pdf2xmlMemoryLimitMb }:
''
#-------------------- start: directories --------------------
# properties of where to find directories necessary for Grobid
# EACH KEY REFERENCING A PATH HAS TO ENDS WITH ".path"
grobid.resource.path= ./resources
grobid.temp.path=${grobidTempPath}
grobid.bin.path= ./bin
#path to folder containing native libraries of 3rd parties
grobid.nativelibrary.path= ${grobidNativeLibsPath}
grobid.3rdparty.pdf2xml.path= ./pdf2xml
grobid.3rdparty.pdf2xml.memory.limit.mb=${toString pdf2xmlMemoryLimitMb}
#-------------------------------------------------------

#-------------------- start: crossref --------------------
#properties to define the account for using crossref (see http://www.crossref.org/)
grobid.crossref_id=id
grobid.crossref_pw=pw
grobid.crossref_host=doi.crossref.org/servlet
grobid.crossref_port=80
#-------------------------------------------------------

#-------------------- start: proxy --------------------
#proxy to be used for external call to the crossref service ("null" when no proxy)
grobid.proxy_host=null
grobid.proxy_port=null
#------------------------------------------------------

#-------------------- start: mySQL --------------------
#properties for connection to mySQL for caching Crossref service calls
grobid.mysql_host=localhost
grobid.mysql_port=3306
grobid.mysql_username=root
grobid.mysql_passwd=root
grobid.mysql_db_name=crossref
#------------------------------------------------------

#-------------------- start: runtime --------------------
grobid.crf.engine=wapiti
#grobid.crf.engine=crfpp

#number of threads for training the crfpp models
grobid.nb_threads=1
#property for using or not the language identifier (true|false)
grobid.use_language_id=true
grobid.language_detector_factory=org.grobid.core.lang.impl.CybozuLanguageDetectorFactory
#determines if properties like the firstnames, lastnames country codes and dictionaries are supposed to be read from $GROBID_HOME path or not (possible values (true|false) dafault is false)
grobid.resources.inHome=true
#------------------------------------------------------

#------------------- start: pooling -------------------
# Maximum parallel connections allowed
org.grobid.max.connections=10
# Maximum time wait to get a connection when the pool is full (in seconds)
org.grobid.pool.max.wait=1
#-------------------------------------------------------
''
