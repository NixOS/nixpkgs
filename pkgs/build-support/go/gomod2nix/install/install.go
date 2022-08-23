package main

import (
	"fmt"
	"go/parser"
	"go/token"
	"io"
	"os"
	"os/exec"
	"strconv"
)

const filename = "tools.go"

func main() {
	fset := token.NewFileSet()

	var src []byte
	{
		f, err := os.Open(filename)
		if err != nil {
			panic(err)
		}

		src, err = io.ReadAll(f)
		if err != nil {
			panic(err)
		}
	}

	f, err := parser.ParseFile(fset, filename, src, parser.ImportsOnly)
	if err != nil {
		fmt.Println(err)
		return
	}

	for _, s := range f.Imports {
		path, err := strconv.Unquote(s.Path.Value)
		if err != nil {
			panic(err)
		}

		cmd := exec.Command("go", "install", path)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr

		fmt.Printf("Executing '%s'\n", cmd)

		err = cmd.Start()
		if err != nil {
			panic(err)
		}

		err = cmd.Wait()
		if err != nil {
			panic(err)
		}
	}
}
