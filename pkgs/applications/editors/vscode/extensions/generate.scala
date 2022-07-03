//> using scala "3.1.1"
//> using lib "org.http4s::http4s-ember-client:0.23.10"
//> using lib "org.http4s::http4s-circe:0.23.10"
//> using lib "io.circe::circe-generic:0.14.1"
import org.http4s.client.dsl.io._
import org.http4s.client.Client
import org.http4s.Uri
import org.http4s.Method.GET
import cats.effect.IO
import org.http4s.circe.CirceEntityCodec._
import io.circe.generic.auto._
import cats.effect.IOApp
import org.http4s.ember.client.EmberClientBuilder
import fs2.io.file.Files
import fs2.io.file.Path
import org.http4s.client.middleware.Logger
import org.http4s.client.middleware.Retry
import org.http4s.client.middleware.RetryPolicy
import scala.concurrent.duration._
import cats.implicits._
import cats.data.NonEmptyList

def nixPrefetchExtension(
    publisher: String,
    name: String,
    version: String
): IO[String] =
  import sys.process._

  val url =
    s"https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  IO.interruptibleMany(s"nix-prefetch-url $url".!!.trim)

def manifest(
    publisher: String,
    name: String
)(c: Client[IO]): IO[Manifest] =
  import org.http4s.circe.CirceEntityCodec._

  val url = Uri.unsafeFromString(
    s"https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/latest/assetbyname/Microsoft.VisualStudio.Code.Manifest"
  )

  c.expect[Manifest](GET(url)).onError { case e =>
    cats.effect.std
      .Console[IO]
      .errorln(
        s"Couldn't get extension version for $publisher.$name"
      )
  }

final case class Manifest(version: String, license: Option[String])

val nixLicenses =
  Map(
    "MIT" -> List("mit"),
    "Apache-2.0" -> List("asl20"),
    "EPL-2.0" -> List("epl20"),
    "MPL-2.0" -> List("mpl20"),
    "BSD-3-Clause" -> List("bsd3"),
    "Unlicense" -> List("unlicense"),
    "MIT OR Apache-2.0" -> List("mit", "asl20"),
    "GPL-3.0" -> List("gpl3"),
    "GPL-3.0-or-later" -> List("gpl3Plus"),
    "ISC" -> List("isc")
  )

case class Extension(
    publisher: String,
    name: String,
    version: String,
    sha256: String,
    license: Option[String]
) {
  def metaString = license match
    case Some(nixLicenses(knownLicenses)) =>
      s"""
      |  meta.license = ${knownLicenses
        .map(l => s"lib.licenses.$l")
        .mkString("[ ", " ", " ]")};""".stripMargin
    case other =>
      // side effect
      println(
        s"${Console.YELLOW}Unknown license for $publisher.$name: $other${Console.RESET}. Add it in overrides.nix."
      )
      ""

  def renderNix: String =
    s"""${escape(publisher)}.$name = buildVscodeMarketplaceExtension {
      |  mktplcRef = {
      |    publisher = "${publisher}";
      |    name = "${name}";
      |    version = "${version}";
      |    sha256 = "${sha256}";
      |  };$metaString
      |};""".stripMargin
}

def escape(publisher: String): String =
  if (publisher.head.isDigit) s"_$publisher" else publisher

def indentLeft(text: String, chars: Int): String =
  text.linesIterator.map(line => s"${" " * chars}$line").mkString("\n")

def surround(before: String, after: String): fs2.Pipe[IO, String, String] =
  fs2.Stream.emit(before) ++ _ ++ fs2.Stream.emit(after)

object Generator extends IOApp.Simple:
  val clientResource = EmberClientBuilder
    .default[IO]
    .build
    .map(
      Retry[IO](RetryPolicy(RetryPolicy.exponentialBackoff(10.seconds, 10)))
    )
    .map(
      Logger(
        logHeaders = false,
        logBody = false,
        logAction = Some(IO.println(_: String))
      )
    )

  val allExtensions = Files[IO]
    .readAll(Path("./extension-names.txt"))
    .through(fs2.text.utf8.decode)
    .through(fs2.text.lines)
    .map(_.trim)
    .filterNot(_.isEmpty)
    .filterNot(_.startsWith("#"))

  def run =
    allExtensions
      .as(1)
      .foldMonoid
      .flatMap { totalCount =>
        fs2.Stream
          .resource(clientResource)
          .flatMap { client =>
            allExtensions
              .map { case s"$publisher.$name" =>
                (publisher, name)
              }
              .parEvalMap(
                // max concurrent requests
                10
              ) { case (publisher, name) =>
                for {
                  manifest <- manifest(publisher, name)(client)
                  _ <- IO.println(
                    s"$publisher.$name: ${manifest.version} (license ${manifest.license})"
                  )
                  sha256 <- nixPrefetchExtension(
                    publisher,
                    name,
                    manifest.version
                  )
                } yield Extension(
                  publisher,
                  name,
                  manifest.version,
                  sha256,
                  manifest.license
                )
              }
              .zipWithIndex
              .evalMap { case (item, i) =>
                val percent = ((i.toDouble / totalCount) * 100).round

                IO.println(
                  s"${Console.GREEN}Fetched $i/$totalCount extensions ($percent%)${Console.RESET}"
                ).as(item)
              }
          }
      }
      .map(_.renderNix)
      .map(indentLeft(_, 2))
      .through(surround("{ buildVscodeMarketplaceExtension, lib }:\n{", "}\n"))
      .intersperse("\n")
      .through(fs2.text.utf8.encode)
      .through(Files[IO].writeAll(Path("./generated.nix")))
      .compile
      .drain
end Generator
