This sets a default value for the tpl directory that works for Nixpkgs.

diff --git a/server/web.go b/server/web.go
index d024a42..0522d02 100644
--- a/server/web.go
+++ b/server/web.go
@@ -10,6 +10,7 @@ import "path/filepath"
 import "time"
 import "strings"
 import "fmt"
+import "os"
 
 var layoutTpl *template.Template
 var mainPageTpl *template.Template
@@ -44,7 +45,11 @@ func deriveTemplate(filename string) (*template.Template, error) {
 }
 
 func (s *Server) tplFilename(filename string) string {
-	td := filepath.Join(s.cfg.ConfigDir, "..", "tpl")
+	ex, err := os.Executable()
+	if err != nil {
+		panic(err)
+	}
+	td := filepath.Join(filepath.Dir(ex), "..", "share", "tpl")
 	if s.cfg.TplPath != "" {
 		td = s.cfg.TplPath
 	}
