import java.awt.Toolkit;
import java.lang.instrument.Instrumentation;
import java.lang.reflect.Field;

/**
 * Java agent that sets the AWT application class name for proper
 * window icon matching on Linux (Wayland/X11).
 *
 * Usage: -javaagent:wm-class-agent.jar=forge
 */
class WmClassAgent {
    public static void premain(String agentArgs, Instrumentation inst) {
        try {
            Toolkit toolkit = Toolkit.getDefaultToolkit();
            if ("sun.awt.X11.XToolkit".equals(toolkit.getClass().getName())) {
                Field f = toolkit.getClass().getDeclaredField("awtAppClassName");
                f.setAccessible(true);
                f.set(toolkit, agentArgs != null ? agentArgs : "java");
            }
        } catch (Exception ignored) {
        }
    }
}
