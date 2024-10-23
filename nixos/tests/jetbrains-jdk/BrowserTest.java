import com.jetbrains.cef.JCefAppConfig;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import javax.swing.JFrame;
import org.cef.CefApp;
import org.cef.CefSettings;
import org.cef.browser.CefRendering;

public class BrowserTest {
    private static void fail(String message) {
        throw new RuntimeException(message);
    }

    public static void main(String[] args) throws InterruptedException {
        var started = CefApp.startup(args);
        var config = JCefAppConfig.getInstance();

	var settings = config.getCefSettings();
	var app = CefApp.getInstance(settings);
        var latch = new CountDownLatch(1);
        app.onInitialization(s -> latch.countDown());
        latch.await(30, TimeUnit.SECONDS);
        if (latch.getCount() > 0) {
            fail("CEF initialization timed out");
        }

        var client = app.createClient();
        var browser = client.createBrowser("chrome://system", CefRendering.DEFAULT, false);
        var frame = new JFrame("browser test");
        frame.add(browser.getUIComponent());
        frame.setSize(640, 480);
        frame.setVisible(true);
    }
}
