using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using AsmResolver.DotNet;
using AsmResolver.DotNet.Resources;
using AsmResolver.IO;
using Spectre.Console;
using Spectre.Console.Cli;

var app = new CommandApp<ExtractCommand>();
app.Configure(config =>
{
    config.SetApplicationName("extract-dotnet-resources");

    config.SetExceptionHandler((exception, _) =>
    {
        if (exception is CommandAppException { Pretty: { } pretty })
        {
            AnsiConsole.Write(pretty);
            return;
        }

        AnsiConsole.WriteException(exception);
    });
});
return app.Run(args);

internal sealed class ExtractCommand : Command<ExtractCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<assemblyPath>")]
        [Required]
        public required string AssemblyPath { get; init; }

        [CommandArgument(1, "<patterns>")]
        public string[] Patterns { get; init; } = [];

        [CommandOption("-o|--output")]
        public string? OutputDirectoryPath { get; init; }
    }

    private class Pattern(Regex regex)
    {
        public Regex Regex { get; } = regex;

        private static Regex ConvertGlobToRegex(string pattern)
        {
            return new Regex(
                "^" + Regex.Escape(pattern).Replace(@"\*", ".*").Replace(@"\?", ".") + "$",
                RegexOptions.IgnoreCase | RegexOptions.Singleline
            );
        }

        public static Pattern Create(string pattern)
        {
            var indexOfSlash = pattern.IndexOf('/');
            if (indexOfSlash != -1)
            {
                var mainPattern = pattern[..indexOfSlash];
                var subPattern = pattern[(indexOfSlash + 1)..];

                return new SubPattern(ConvertGlobToRegex(mainPattern), ConvertGlobToRegex(subPattern));
            }

            return new Pattern(ConvertGlobToRegex(pattern));
        }
    }

    private class SubPattern(Regex regex, Regex subRegex) : Pattern(regex)
    {
        public Regex SubRegex { get; } = subRegex;
    }

    private static bool IsResourceSet(BinaryStreamReader reader)
    {
        if (reader.Length < sizeof(uint)) return false;
        return reader.ReadUInt32() == ResourceManagerHeader.Magic;
    }

    private static string Sanitize(string entryPath)
    {
        return entryPath.Replace('\0', '_').Replace('/', '_').Replace('\\', '_');
    }

    public override int Execute(CommandContext context, Settings settings)
    {
        var outputDirectoryPath = Path.GetFullPath(settings.OutputDirectoryPath ?? Directory.GetCurrentDirectory());
        Directory.CreateDirectory(outputDirectoryPath);

        var module = ModuleDefinition.FromFile(settings.AssemblyPath);

        if (!module.Resources.Any())
        {
            AnsiConsole.MarkupLine("[red]Provided assembly has no resources[/]");
            return 1;
        }

        var patterns = settings.Patterns.Select(Pattern.Create).ToArray();

        foreach (var manifestResource in module.Resources)
        {
            if (manifestResource.Name is null) continue;

            var matchingPatterns = patterns.Where(pattern => pattern.Regex.IsMatch(manifestResource.Name)).ToArray();
            if (matchingPatterns.Length == 0)
            {
                continue;
            }

            if (manifestResource.TryGetReader(out var reader))
            {
                if (IsResourceSet(reader))
                {
                    if (!matchingPatterns.Any(pattern => pattern is SubPattern))
                    {
                        continue;
                    }

                    var resourceSet = ResourceSet.FromReader(reader);

                    foreach (var entry in resourceSet)
                    {
                        if (entry == null) continue;

                        if (matchingPatterns.OfType<SubPattern>().All(subPattern => !subPattern.SubRegex.IsMatch(entry.Name)))
                        {
                            continue;
                        }

                        AnsiConsole.MarkupLineInterpolated($"Extracting [darkcyan]{manifestResource.Name}[/][gray]/[/][cyan]{entry.Name}[/]");

                        var path = Path.GetFullPath(Path.Combine(outputDirectoryPath, Sanitize(manifestResource.Name), Sanitize(entry.Name)));
                        if (!path.StartsWith(outputDirectoryPath))
                            throw new IOException("Extracting would have resulted in a file outside the specified destination directory");

                        Directory.CreateDirectory(Path.GetDirectoryName(path)!);

                        switch (entry.Data)
                        {
                            case byte[] bytes:
                            {
                                File.WriteAllBytes(path, bytes);
                                break;
                            }

                            case string text:
                            {
                                File.WriteAllText(path, text);
                                break;
                            }

                            default:
                                throw new NotSupportedException($"Can't handle {entry.Data} ({entry.Type.FullName})");
                        }
                    }
                }
                else
                {
                    if (!matchingPatterns.Any(pattern => pattern is not SubPattern))
                    {
                        continue;
                    }

                    AnsiConsole.MarkupLineInterpolated($"Extracting [cyan]{manifestResource.Name}[/]");

                    var path = Path.GetFullPath(Path.Combine(outputDirectoryPath, Sanitize(manifestResource.Name)));
                    if (!path.StartsWith(outputDirectoryPath))
                        throw new IOException("Extracting would have resulted in a file outside the specified destination directory");

                    using var fileStream = File.Create(path);
                    reader.WriteToOutput(new BinaryStreamWriter(fileStream));
                }
            }
        }

        return 0;
    }
}
